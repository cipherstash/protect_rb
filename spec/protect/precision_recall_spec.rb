# Create 100 user records
# query email
# return precision
# number of relevant documents retrieved divided by the total number of retrieved documents.
#  Precision = relevant documents retrieved / retrieved documents
# recall
# number of relevant documents retrieved divided by the total of all relevant documents
# Recall = relevant documents retrieved / relevant documents


RSpec.describe "Bloom filter precision and recall stats" do
  VALID_BLOOM_FILTER_ID = "4f108250-53f8-013b-0bb5-0e015c998818"
    FILTER_SIZE = 256
    FILTER_TERM_BITS = 3
    TOKEN_FILTERS = [{kind: :downcase}, {kind: :ngram, token_length: 3}]
    TOKENIZER = { kind: :standard }

    let(:model) {
      Class.new(ActiveRecord::Base) do
        self.table_name = CrudTesting.table_name

        secure_text_search :email,
          filter_size: FILTER_SIZE,filter_term_bits: FILTER_TERM_BITS,
          bloom_filter_id: VALID_BLOOM_FILTER_ID,
          tokenizer: TOKENIZER,
          token_filters: TOKEN_FILTERS
      end
    }

    let(:filter) {
      CipherStash::Protect::ActiveRecordExtensions::BloomFilter.new(VALID_BLOOM_FILTER_ID,
        {
          filter_size: FILTER_SIZE,
          filter_term_bits: FILTER_TERM_BITS
        }
      )
    }

    let(:text_processor) {
      CipherStash::Protect::Analysis::TextProcessor.new(
        {
          token_filters: TOKEN_FILTERS,
          tokenizer: TOKENIZER
        }
      )
    }

  let(:users) {
    [
     { email: "vickhorny@hotmail.com" },
     { email: "luluphilosophic@outlook.com" },
     { email: "ralphiemean@live.com" },
     { email: "delwise@icloud.com" },
     { email: "hopefulgeorge@aol.com" },
     { email: "afraidcon@icloud.com" },
     { email: "anticipatingvickie@gmail.com" },
     { email: "awkwardtrace@mac.com" },
     { email: "lootenlightened@gmail.com" },
     { email: "invalidateunnatural@verizon.net" },
     { email: "clingjealous@comcast.net" },
     { email: "aggravateamused@comcast.net" },
     { email: "quantifytorn@aol.com" },
     { email: "toleratecultured@mac.com" },
     { email: "whistlefair@gmail.com" },
     { email: "betterappropriate@icloud.com" },
     { email: "hitchusable@protonmail.com" },
     { email: "justifyamusing@mac.com" },
     { email: "bullywhispered@yahoo.com" },
     { email: "attaindim@yahoo.ca" },
     { email: "sufferjaded@aol.com" },
     { email: "welcomeprevious@hotmail.com" },
     { email: "thwartformal@yahoo.ca" },
     { email: "linkstarchy@yahoo.com" },
     { email: "saddleshallow@mac.com" },
     { email: "interceptsour@att.net" },
     { email: "grateloathsome@protonmail.com" },
     { email: "swapextra-small@yahoo.com" },
     { email: "fightqueasy@comcast.net" },
     { email: "taxjoyful@yahoo.ca" },
     { email: "aggregateneglected@aol.com" },
     { email: "engulfneedy@aol.com" },
     { email: "mockfragrant@optonline.net" },
     { email: "regulateflippant@comcast.net" },
     { email: "scarflashy@me.com" },
     { email: "wearicky@att.net" },
     { email: "gradebiodegradable@yahoo.com" },
     { email: "smoothawful@gmail.com" },
     { email: "schedulerough@live.com" },
     { email: "featurefearless@live.com" },
     { email: "decentralizefrugal@msn.com" },
     { email: "dissuadeimmaculate@gmail.com" },
     { email: "expressour@hotmail.com" },
     { email: "squealeminent@mac.com" },
     { email: "safeguardgregarious@optonline.net" },
     { email: "dannie@hahn.name"},
     { email: "marissa@hartmann.com" },
     { email: "mariann@williamson.org" },
     { email: "marybeth@kertzmann-bailey.org" },
     { email: "danna@cummings.info" }
    ]
  }

  before do
    model.insert_all!(users)
  end

  it "test precision" do
    tokens = text_processor.perform("danna@cummings.info")
    bits = filter.add(tokens).postgres_bits_from_native_bits

    users = model.find(:all, :conditions => ["email_secure_text_search @> ?", bits])
    # expect(users.length)
    binding.pry
  end
end
#  query = <<~SQL.squish
#         (lower(concat(first_name, ' ', last_name)) like ?) OR
#         (lower(phone) like ?) OR
#         (lower(email) like ?)
#       SQL

# Book.find(:all,
#   :conditions => ["created_at >= ? AND created_at <= ? AND updated_at <= ?",
#                   date1, date2, date3]