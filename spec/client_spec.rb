require 'spec_helper'
require 'json'

describe Sypht::Client do
  before :all do
    client_id, client_secret = ENV['SYPHT_API_KEY'].split(":")
    @client = Sypht::Client.new(client_id, client_secret)
  end

  context 'upload' do

    invoice_keys_to_check = %w(invoice.gst invoice.subTotal invoice.tax invoice.dueDate invoice.total
                               invoice.amountPaid invoice.amountDue invoice.purchaseOrderNo)
    document_keys_to_check  = %w(document.date document.type document.referenceNo document.supplierGSTN
                               document.supplierABN)

    context 'when wrong_field_set' do
      it 'fails' do
        expect {
          upload_invoice ['sypht.incorrect', ]
        }.to raise_error(ArgumentError)
      end
    end

    context 'invoice' do
      it 'fieldset invoice' do
        fid = upload_invoice ['sypht.invoice', ]
        expect { validate_uuid_format(fid)}
        results = @client.fetch_results fid
        # puts JSON.pretty_generate results
        check_keys(invoice_keys_to_check,results)
        check_no_keys(document_keys_to_check,results)
      end

      it 'fieldset document' do
        fid = upload_invoice ["sypht.document"]
        expect {validate_uuid_format(fid)}
        results = @client.fetch_results fid
        # puts JSON.pretty_generate results
        check_keys(document_keys_to_check,results)
        check_no_keys(invoice_keys_to_check,results)
      end

      it 'fieldset invoice+document' do
        fid = upload_invoice ['sypht.invoice', "sypht.document"]
        expect {validate_uuid_format(fid)}
        results = @client.fetch_results fid
        # puts JSON.pretty_generate results
        check_keys(invoice_keys_to_check,results)
        check_keys(document_keys_to_check,results)
      end
    end
  end
end