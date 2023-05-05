class SudokuController < ApplicationController
  @@sudokufull = Array.new(Array.new(1))

  def fill_sudokufull(sudoku)
    if @@sudokufull[0].nil?
      @@sudokufull = sudoku
      return "filling"
    end
    return "go away stranger"
  end
  def sudokugenerate
    # Генерація порожньої матриці судоку
    sudoku = Array.new(9) { Array.new(9, 0) }

    # Функція для перевірки, чи дозволено розмістити число n в клітинці (row, col)
    def allowed_number(sudoku, row, col, n)
      # Перевірити, чи число n вже присутнє в рядку або стовпці
      (0..8).each do |i|
        return false if sudoku[row][i] == n || sudoku[i][col] == n
      end

      # Перевірити, чи число n вже присутнє в квадраті 3x3, до якого належить клітинка (row, col)
      row_start = (row / 3) * 3
      col_start = (col / 3) * 3
      (row_start..(row_start + 2)).each do |i|
        (col_start..(col_start + 2)).each do |j|
          return false if sudoku[i][j] == n
        end
      end

      # Якщо число n не зустрічається в рядку, стовпці та квадраті 3x3, то дозволяється його розмістити
      true
    end

    # Функція для заповнення матриці судоку з використанням алгоритму повернення назад
    def fill_sudoku(sudoku, row, col)
      # Якщо заповнено всі клітинки в останньому рядку, то судоку згенеровано
      if row == 8 && col == 9
        return true
      end

      # Якщо заповнено всі клітинки у поточному рядку, перейти до наступного рядка
      if col == 9
        row += 1
        col = 0
      end

      # Якщо поточна клітинка не порожня, перейти до наступної клітинки
      if sudoku[row][col] != 0
        return fill_sudoku(sudoku, row, col + 1)
      end

      # Спробувати розмістити числа від 1 до 9 в поточній клітинці
      (1..9).to_a.shuffle.each do |n|
        if allowed_number(sudoku, row, col, n)
          sudoku[row][col] = n
          if fill_sudoku(sudoku, row, col + 1)
            return true
          end
          # Якщо наступна клітинка не може бути заповнена, повернутися назад і спробувати інше число
          sudoku[row][col] = 0
        end
      end
      # Якщо жодне число не може бути розміщене в поточній клітинці, повернутися назад і спробувати іншу комбінацію
      false
    end

    # Заповнити матрицю судоку використовуючи алгоритм повернення назад
    fill_sudoku(sudoku, 0, 0)
    sudoku.each do |row|
      puts row.join(" ")
    end
    return sudoku
  end

  def index
    difficulty = 5

    def parse_params(params)
      allowed_params = params.permit(:difficulty)
      allowed_params.to_h
    end
    if params.has_key?(:difficulty)
      parsed_params = parse_params(params)
      tempdiff = parsed_params[:difficulty]
      difficulty = tempdiff.to_i
    end
    @@sudokufull = sudokugenerate()
    @sudoku = @@sudokufull.map(&:clone)
    for a in 1..difficulty do
      x = rand(9)
      y = rand(9)
      @sudoku[x][y] = 0
    end
    if params.has_key?(:difficulty)
      render template: "sudoku/index"
    end
  end

  def take_params_and_fill
    filled_sudoku = @@sudokufull

    def parse_params(params)
      allowed_params = params.permit(cell: {})
      allowed_params.to_h
    end
    int_array = []
    indexx_array = []
    indexy_array = []
    parsed_params = parse_params(params)
    parsed_params["cell"].each do |row_index, row|
      row.each do |col_index, value|
        # Convert the value to an integer and add it to the array
        indexy_array << col_index.to_i unless value.empty?
        indexx_array << row_index.to_i unless value.empty?
        int_array << value.to_i unless value.empty?
      end
    end

    value_index = 0
    false_flag = true

    int_array.each do |z|
      if filled_sudoku[indexx_array[value_index]][indexy_array[value_index]] != z
        false_flag = false
      end
      value_index += 1
    end
    if false_flag
      redirect_to sudoku_solve_path(answer: "Your answer is correct or you have not entered anything")
    else
      redirect_to sudoku_solve_path(answer: "Not correct try again")
    end
  end

  def solve
    render "sudoku/solve"
  end
end