class AddScreenshotToPageRevisions < ActiveRecord::Migration
  def change
    add_column "#{Landable.configuration.database_schema_prefix}landable.page_revisions", :screenshot, :text
  end
end
