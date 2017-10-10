# frozen_string_literal: true

require 'forwardable'

Dir[File.join(__dir__, '../**/repository.rb')].each { |repository_file| require repository_file }
Dir[File.join(__dir__, '../**/account.rb')].each { |account_file| require account_file }
Dir[File.join(__dir__, '../**/api_helper.rb')].each { |helper_file| require helper_file }
Dir[File.join(__dir__, '../services/*.rb')].each { |helper_file| require helper_file }

module Geet
  module Git
    # This class represents, for convenience, both the local and the remote repository, but the
    # remote code is separated in each provider module.
    class Repository
      extend Forwardable

      def_delegators :@remote_repository, :collaborators, :labels, :create_pr
      def_delegators :@account, :authenticated_user

      DOMAIN_PROVIDERS_MAPPING = {
        'github.com' => Geet::GitHub
      }.freeze

      def initialize(api_token)
        the_provider_domain = provider_domain
        provider_module = DOMAIN_PROVIDERS_MAPPING[the_provider_domain] || raise("Provider not supported for domain: #{provider_domain}")

        api_helper = provider_module::ApiHelper.new(api_token, user, owner, repo)

        @remote_repository = provider_module::Repository.new(self, api_helper)
        @account = provider_module::Account.new(api_helper)
      end

      # METADATA

      def user
        `git config --get user.email`.strip
      end

      def provider_domain
        remote_origin[/^git@(\S+):/, 1]
      end

      def owner
        remote_origin[%r{git@\S+:(\w+)/}, 1] || raise('Internal error')
      end

      def repo
        remote_origin[%r{/(\w+)\.git$}, 1] || raise('Internal error')
      end

      # DATA

      def current_head
        `git rev-parse --abbrev-ref HEAD`.strip
      end

      # OTHER

      private

      # The result is in the format `git@github.com:saveriomiroddi/geet.git`
      #
      def remote_origin
        origin = `git ls-remote --get-url origin`.strip

        if origin !~ %r{\Agit@\S+:\w+/\w+\.git\Z}
          raise("Unexpected remote reference format: #{origin.inspect}")
        end

        origin
      end
    end
  end
end