require 'spec_helper'

describe SyphtClient do
  before :all do
    @client = SyphtClient.new(ENV['SYPHT_CLIENT_ID'], ENV['SYPHT_CLIENT_SECRET'])
  end

  context 'upload' do
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
        KEYS_TO_CHECK = %w(invoice.dueDate invoice.total invoice.amountPaid invoice.amountDue)
        check_keys(KEYS_TO_CHECK,results)
      end
      it 'fieldset invoice+bank' do
        fid = upload_invoice ['sypht.invoice', "sypht.bank"]
        expect {validate_uuid_format(fid)}
        results = @client.fetch_results fid
        KEYS_TO_CHECK = %w(invoice.dueDate invoice.total invoice.amountPaid invoice.amountDue bank.accountNo bank.bsb)
        check_keys(KEYS_TO_CHECK,results)
      end
    end
  end
end