require 'csv'
require './my_sqlite_request.rb'

def parse_command_sort(command)
  tokens = command.split
  db_sqlite = MySqliteRequest.new
  save_title = ""

  tokens.each_with_index do |token, index|
    case token
    when "SELECT"
      analysis_save = tokens[index + 1].include?(",") ? tokens[index + 1].split(",") : tokens[index + 1]
      db_sqlite = db_sqlite.select(analysis_save)
    when "FROM"
      db_sqlite = db_sqlite.from(tokens[index + 1])
    when "WHERE"
      where_clause = command.split("WHERE").last.split("=").map(&:strip)
      db_sqlite = db_sqlite.where(where_clause[0], where_clause[1].gsub(/^'|'$/, ''))
    when "INSERT"
      if tokens[index + 1] == "INTO"
        save_title = tokens[index + 2]
        db_sqlite = db_sqlite.insert(save_title)
      end
    when "UPDATE"
      db_sqlite = db_sqlite.update(tokens[index + 1])
      puts tokens[index + 1]
    when "DELETE"
      db_sqlite = db_sqlite.delete
    when "VALUES"
      save_title = tokens[index - 1] if tokens[index - 1] == "INTO"
      values = File.read(save_title).split("\n")[0] << "\n" << command.split("VALUES")[1].gsub(/[()]/, '')
      arr_data = CSV.parse(values, headers: true).map(&:to_h)
      db_sqlite = db_sqlite.values(arr_data[0])
    when "SET"
      my_sstr = ""
      (index + 1...tokens.length).each do |i|
        break if tokens[i] == "WHERE"
        my_sstr << tokens[i] << " "
      end
      for_hashing = Hash[my_sstr.scan(/(\w+)\s*=\s*'([^']+)'/)]
      db_sqlite = db_sqlite.values(for_hashing)
    end
  end
  db_sqlite.run
end

def ruby_main
  while get_readed = $stdin.gets
    break if get_readed.include?("quit")
    parse_command_sort(get_readed)
    print "my_sqlite_cli>"
  end
end

print "my_sqlite_cli>"
ruby_main
