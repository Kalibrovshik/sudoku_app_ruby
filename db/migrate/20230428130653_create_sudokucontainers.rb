class CreateSudokucontainers < ActiveRecord::Migration[7.0]
  def change
    create_table :sudokucontainers do |t|
      t.string :containedwords

      t.timestamps
    end
  end
end
