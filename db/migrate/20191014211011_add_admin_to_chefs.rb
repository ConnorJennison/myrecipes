class AddAdminToChefs < ActiveRecord::Migration[5.2]
  def change
		add_column :chefs, :admin, :boolean, deafult: false
  end
end
