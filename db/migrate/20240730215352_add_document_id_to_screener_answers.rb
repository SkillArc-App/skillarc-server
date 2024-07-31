class AddDocumentIdToScreenerAnswers < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :screeners_answers, bulk: true do |t|
        t.uuid :documents_screeners_id
        t.string :document_status
      end
    end
  end
end
