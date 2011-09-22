# Prefix for TERP custom objects
ActiveRecord::Base.table_name_prefix = 'xxdemo_'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
    # id columns and columns which end with _id will always be converted to integers
    self.emulate_integers_by_column_name = true
    # DATE columns which include "date" in name will be converted to Date, otherwise to Time
    self.emulate_dates_by_column_name = true
    # true and false will be stored as 'Y' and 'N'
    self.emulate_booleans_from_strings = true
  end

  plsql.activerecord_class = ActiveRecord::Base
end
