class CreateMensajes < ActiveRecord::Migration[5.1]
  def change
    create_table :mensajes do |t|
      t.text :contenido

      t.timestamps
    end
  end
end
