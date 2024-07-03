require 'rails_helper'

RSpec.describe "No pending migration" do
  it "There are no pending migrations" do
    expect { ActiveRecord::Migration.check_pending! }.not_to raise_error
  end
end
