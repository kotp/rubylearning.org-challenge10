=begin
 
 multiplication_table (integer, heading = '', decorate = false)
      returns a string object.
=end

def indent( text, cols )
  text.split(/\r|\r\n|\n/).map {|line| " "*cols << line}
end

def make_heading( heading, width=0 )
  !heading.empty? ? heading.center(width) << $/ : ""
end

def make_decoration(width)
  "=" * width << $/
end

def multiplication_table( integer, heading = '', decorate = false)
  times_table = []
  if integer == 0
    times_table[0] = [0]
  else
    integer.abs.times do |y|
      times_table[y] = []
      integer.abs.times do |x|
        times_table[y][x]=(x+1)*(y+1)
      end
    end
  end

  max_value = times_table[times_table.size-1][times_table.size-1]
  first_column_width = integer.to_s.size+1
  other_column_width = max_value.to_s.size
  table_width = first_column_width + 1 + (other_column_width+1) * (times_table.size-1)
  
  heading_str = make_heading(heading, table_width)
  decoration = decorate ? make_decoration(table_width) : ""
  table_str = times_table.inject("") do |acc,row|
    row.each_with_index do |v,i|
          this_width = i==0 ? first_column_width : other_column_width
	  acc << v.to_s.rjust(this_width) << " "
	end
	acc << $/
  end
  indent( heading_str + decoration + table_str + decoration, 1 )
end

=begin
  The above is the implementation, here's some code to do some tests.
=end

require 'getoptlong'

def usage(msg)
  puts msg if msg
  puts "Usage: #{$0} [-d] [-h] <number> [<number>...]"
  puts <<-EOF
	Prints times tables for the given numbers.
	If -d is given, some table decoration is applied.
	If -h is given, a heading is applied to each table.
	EOF
  exit(1)
end

opts = GetoptLong.new(
  [ "--decorate", "-d", GetoptLong::NO_ARGUMENT ],
  [ "--heading", "-h", GetoptLong::NO_ARGUMENT ]
)

opt_decorate = opt_heading = false
opts.each do |opt,arg|
  case opt
    when '--decorate' then opt_decorate = true
    when '--heading' then opt_heading = true
    else usage "Unknown option '#{opt}'"
  end
end

while i = ARGV.shift
  puts multiplication_table(i.to_i, opt_heading ? "x#{i}" : "", opt_decorate)
  puts unless ARGV.empty?
end
