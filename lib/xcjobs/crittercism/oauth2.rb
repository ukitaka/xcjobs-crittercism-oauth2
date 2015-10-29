require "xcjobs/crittercism/oauth2/version"
require 'xcjobs/distribute'

module XCJobs
  module Distribute
    class Crittercism

      class OAuth2 < Rake::TaskLib
        include Rake::DSL if defined?(Rake::DSL)
        include Distribute

        # required
        attr_accessor :app_id
        attr_accessor :token
        attr_accessor :dsym

        def initialize()
          yield self if block_given?
          @upload_url = "https://files.crittercism.com/api/v1/applications/#{app_id}/symbol-uploads"
          @process_symbol_url = "https://app.crittercism.com/v1.0/app/#{app_id}/symbols/uploads"
          @oauth_header = "-H 'Authorization: Bearer #{token}'"
          define
        end

        private

        def define
          namespace :distribute do
            desc 'upload & process dSYMs to Crittercism using OAuth2'
            task :crittercism_oauth2 do
              begin
                resource_id = create_resource_id
                upload_dsym(resource_id)
                process_symbols(resource_id)
              rescue => ex
                fail ex
              end
            end
          end
        end

        def create_resource_id
          response = `/usr/bin/curl -X POST #{@upload_url} #{@oauth_header}  --silent`
          resource_id = JSON.parse(response)["resource-id"]
          if resource_id.nil? then
            throw "Crittercism Resource FAILED create"
          end
          resource_id
        end

        def upload_dsym(resource_id)
          response = `/usr/bin/curl -X PUT #{@upload_url}/#{resource_id} --write-out %{http_code} --silent --output /dev/null -F name=symbolUpload -F filedata=@"#{dsym}" #{@oauth_header}`
          if response != "202" then
            throw "Crittercism Resource #{resource_id} Uploaded: FAILED #{response}"
          end
        end

        def process_symbols(resource_id)
          json = '{ "uploadUuid": "' + resource_id + '", "filename":"upload.zip" }'
          response = `/usr/bin/curl  --write-out %{http_code} --silent --output /dev/null -X POST "#{process_symbol_url}" --silent -d '#{json}' #{oauth_header} -H 'Content-Type: application/json'`
          if response != "200" then
            throw "Crittercism Resource #{resource_id} Processed: FAILED #{response}"
          end
        end

      end
    end
  end
end
