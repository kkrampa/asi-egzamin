class RenameConfigsToSmsConfigs < ActiveRecord::Migration
  def change
    rename_table 'configs', 'sms_configs'
  end
end
