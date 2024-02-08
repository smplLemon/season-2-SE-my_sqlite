require './my_sqlite_request.rb'
require 'csv'

def func_for_sorting(command)
    db_sqlite = MySqliteRequest.new
    string_value = command.include?("VALUES") ? command.split('VALUES')[1].strip : nil
    command = command.split(" ")
    @save_title = ""

    for i in 0...command.length
        case command[i]
        when "SELECT"
            analysis_save = command[i + 1].include?(",") ? command[i + 1].split(",") : command[i + 1]
            db_sqlite = db_sqlite.select(analysis_save)
        when "FROM"
            db_sqlite = db_sqlite.from(command[i + 1])
        when "WHERE"
            analysis_save = command.join(" ").split("WHERE").last.split("=").map(&:strip)
            db_sqlite = db_sqlite.where(analysis_save[0], analysis_save[1].gsub(/^'|'$/, ''))
        when "INSERT"
            if command[i + 1] == "INTO"
                i += 2
                @save_title = command[i]
                db_sqlite = db_sqlite.insert(command[i])
            end
        when "UPDATE"
            db_sqlite = db_sqlite.update(command[i + 1])
            puts command[i + 1]
        when "DELETE"
            db_sqlite = db_sqlite.delete()
        when "VALUES"
            i += 1
            in_val = File.read(@save_title).split("\n")[0]
            in_val << "\n"
            in_val << string_value.gsub(/[()]/, '')
            arr_data = CSV.parse(in_val, headers: true).map(&:to_h)
            db_sqlite = db_sqlite.values(arr_data[0])
        when "SET"
            i += 1
            my_sstr = ""
            x = i
            for x in 0..(command.length - 1)
                break if command[x] == "WHERE"
                my_sstr << command[x]
                my_sstr << " "
              end
            for_hashing = {}
            my_sstr.scan(/(\w+)\s*=\s*'([^']+)'/) do |name_col, val|
                for_hashing[name_col] = val
            end
            db_sqlite = db_sqlite.values(for_hashing)
        end
    end
    db_sqlite.run
end


def ruby_main
    while get_readed = $stdin.gets
        if get_readed.include?("quit")
            return
        end
        func_for_sorting(get_readed)
        print "my_sqlite_cli>"
    end
end


print "my_sqlite_cli>"
ruby_main
