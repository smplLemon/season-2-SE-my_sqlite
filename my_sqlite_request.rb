require 'csv'

class MySqliteRequest
  def initialize
    @get_table_name = ''
    @column_name = []
    @request_type = ''
    @for_where = {}
    @my_val = {}
  end

  def select(get_column_name)
    @column_name = [get_column_name]
    @request_type = 'SELECT'
    self
  end
  def self.select(get_column_name)
    @column_name = get_column_name
    @request_type = 'SELECT'
    return self.new
  end


  def where(param_1, param_2)
    @for_where[param_1] = param_2
    return self
  end
  def self.where(param_1, param_2)
    @for_where[param_1] = param_2
    return self.new
  end


  def insert(table_name)
    @get_table_name = table_name
    @request_type = 'INSERT'
    return self
  end
  def self.insert(table_name)
    @get_table_name = table_name
    @request_type = 'INSERT'
    return self.new
  end


  def from(table_name)
    @get_table_name = table_name
    return self
  end
  def self.from(table_name)
    @get_table_name = table_name
    return self.new
  end


  def values(my_values)
    @my_val = my_values
    return self
  end
  def self.values(my_values)
    @my_val = my_values
    return self.new
  end


  def delete()
    @request_type = 'DELETE'
    return self
  end
  def self.delete()
    @request_type = 'DELETE'
    return self.new
  end


  def update(param_1)
    @get_table_name = param_1
    @request_type = 'UPDATE'
    return self
  end

  def self.update(param_1)
    @request_type = 'UPDATE'
    return self.new
  end

#---------------------------------------------RUN----------------------------------------------

  def run
    case @request_type
    when 'SELECT'
      select_section
    when 'DELETE'
      delete_section
    when 'INSERT'
      insert_section
    when 'UPDATE'
      update_section
    end
  end


  def update_all_elements(hashing_case, update_values)
    updated_elements = []
    hashing_case.each do |elem|
      elem[update_values.keys[0]] = update_values[update_values.keys[0]]
      realization(elem)
      updated_elements << elem
    end
    updated_elements
  end

  def update_selected_elements(hashing_case, update_values, where_conditions)
    updated_elements = []
    hashing_case.each do |box|
      where_conditions.each do |key_elem, my_val|
        if box[key_elem] == my_val
          update_values.each do |c, f|
            box[c] = f
          end
        end
      end
      realization(box)
      updated_elements << box
    end
    updated_elements
  end

  def update_section
    hashing_case = CSV.read(@get_table_name, headers: true).map(&:to_h)
    File.write(@get_table_name, "#{hashing_case[0].keys.join(",")}", mode: 'w')
    if @for_where.empty?
      updated_elements = update_all_elements(hashing_case, @my_val)
    else
      updated_elements = update_selected_elements(hashing_case, @my_val, @for_where)
    end
    File.write(@get_table_name, "#{hashing_case[0].keys.join(",")}", mode: 'a') # Append header again
    updated_elements
  end


  def delete_records(records)
    my_rehearse = []
    records.each do |elem|
      sign = 0
      @for_where.each do |key_elem, my_val|
        if elem[key_elem] == my_val
          sign = 1
        end
      end
      my_rehearse << realization(elem) if sign == 0
    end
    my_rehearse
  end

  def delete_section
    get_title = CSV.read(@get_table_name, headers: true).map(&:to_h)
    File.write(@get_table_name, "#{get_title[0].keys.join(",")}", mode: 'w')
    return [] if @for_where.empty?
    delete_records(get_title)
  end


  def realization(insert_elem)
    my_sstring = ""
    ind = 0
    insert_elem.each do |key_elem, text|
      if text.to_s.include?(",")
        my_sstring += (ind < insert_elem.length - 1) ? "\"#{text}\"," : "\"#{text}\""
      else
        my_sstring += (ind < insert_elem.length - 1) ? "#{text}," : "#{text}"
      end
      ind += 1
    end
    File.write(@get_table_name, "\n#{my_sstring}", mode: 'a')
  end

  def insert_section
    my_sstring = ""
    ind = 0
    @my_val.each do |key_elem, text|
      if text.to_s.include?(",")
        my_sstring += (ind < @my_val.length - 1) ? "\"#{text}\"," : "\"#{text}\""
      else
        my_sstring += (ind < @my_val.length - 1) ? "#{text}," : "#{text}"
      end
      ind += 1
    end
    File.write(@get_table_name, "\n#{my_sstring}", mode: 'a')
  end


  def select_section
    table_read = CSV.parse(File.read(@get_table_name), headers: true).map(&:to_h)
    saving_bracket = []
    puts @get_table_name
    table_read.each do |my_row|
      for_return = []
      if @for_where.empty? || @for_where.all? { |key_elem, my_val| my_row[key_elem] == my_val }
        if @column_name[0] == "*"
          p my_row
          for_return << my_row
        else
          tamp = {}
          @column_name.flatten.each { |i| tamp[i] = my_row[i] }
          p tamp
          for_return << tamp
        end
        saving_bracket << for_return
      end
    end
    saving_bracket
  end
end
