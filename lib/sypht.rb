require "sypht/version"
require 'rest_client'
require 'json'

module Sypht
  class Client
    API_BASE_ENDPOINT = 'https://api.sypht.com'
    AUTH_ENDPOINT = 'https://login.sypht.com/oauth/token'

    FIELDSET = {
      "GENERIC": 'sypht.generic',
      "DOCUMENT": 'sypht.document',
      "INVOICE": 'sypht.invoice',
      "BILL": 'sypht.bill',
      "BANK": 'sypht.bank'
    }

    FINALISED = "FINALISED"


  # @param [String] client_id Your Sypht-provided OAuth client_id.
  # @param [String] client_secret Your Sypht-provided OAuth client_secret
    def initialize(client_id, client_secret, base_endpoint=API_BASE_ENDPOINT, auth_endpoint=AUTH_ENDPOINT)
      @client_id = client_id
      @client_secret = client_secret
      @base_endpoint = base_endpoint
      @auth_endpoint = auth_endpoint
      @audience = ENV["SYPHT_AUDIENCE"] || @base_endpoint
      @access_token = authenticate
    end

    def upload(file, fieldsets, tags=nil, endpoint=nil, workflow=nil, options=nil)
      headers = {
          "Authorization": "Bearer " + @access_token,
          multipart: true
      }
      endpoint ||= API_BASE_ENDPOINT + "/fileupload"

      data = {
        fieldsets: parse_fieldsets(fieldsets),
        'fileToUpload': File.new(file, 'rb')
      }
      if tags
        data['tags'] = tags
      end
      if workflow
        data['workflowId'] = workflow
      end
      if options
        data['workflowOptions'] = JSON.dump(options)
      end

      result = JSON.parse(RestClient.post(endpoint, data, headers))

      unless result.key?('fileId')
        raise Exception('Upload failed with response: ' + JSON.dump(result))
      end
      result['fileId']
    end

    def fetch_results(file_id, endpoint=nil)
      headers = {
        "Authorization": "Bearer " + @access_token
      }
      endpoint ||= API_BASE_ENDPOINT + "/result/final/" + file_id
      result = JSON.parse(RestClient::Request.execute(method: :get, url: endpoint,  headers: headers, timeout: 300))

      if result['status'] != FINALISED
        return nil
      end
      result['results']
    end

    private
    def authenticate
      endpoint = ENV["SYPHT_AUTH_ENDPOINT"] || @auth_endpoint
      data = {
          client_id: @client_id,
          client_secret: @client_secret,
          audience: @audience,
          grant_type: 'client_credentials'
      }
      result = JSON.parse(RestClient.post(endpoint, data))
      if result['error_description']
        raise Exception, 'Authentication failed: {}'.format(result['error_description'])
      else
        result['access_token']
      end
    end

    def parse_fieldsets(fieldsets)
      out = []
      fieldsets.each do |fs|
        if FIELDSET.key? fs
          out.append(FIELDSET[fs])
        elsif FIELDSET.has_value? fs
          out.append(fs)
        else
          raise ArgumentError, "Undefined fileset"
        end
      end
      out
    end
  end
end
