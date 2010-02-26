=begin
 
 multiplication_table (integer, heading = '', decorate = false)
      returns a string object.
=end

def indent( text, cols )
  text.split(/\r|\r\n|\n/).map {|line| " "*cols << line}.join($/) << $/
end

def make_heading( heading, width=0, centre=false )
  (heading==nil) ? "" : heading.center(centre ? width : 0).rstrip << $/
end

def make_decoration(width)
  "=" * width << $/
end

def multiplication_table( integer, heading = '', decorate = false, centre = false)
  times_table = []
  if integer == 0
    times_table << [0]
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
  
  heading_str = make_heading(heading, table_width, centre)
  decoration = decorate ? make_decoration(table_width) : ""
  table_str = times_table.inject("") do |acc,row|
    row.each_with_index do |v,i|
          this_width = i==0 ? first_column_width : other_column_width+1
	  acc << v.to_s.rjust(this_width)
	end
	acc << $/
  end
  indent( heading_str + decoration + table_str + decoration, 1 )
end

=begin
  The above is the implementation, here's some code to do some tests.
=end

require 'getoptlong'

def usage(msg=nil)
  puts msg if msg
  puts "Usage: #{$0} [-d] [-h <heading_text>] [-c] <number> [<number>...]"
  puts <<-EOF
	Prints times tables for the given numbers.
	If -d is given, some table decoration is applied.
	If -h is given, a heading is applied to each table.
		In the <heading_text> '$' will be replaced with the table number.
	If -c is given, any heading is centred on the table.
	EOF
  exit(1)
end

opts = GetoptLong.new(
  [ "--decorate", "-d", GetoptLong::NO_ARGUMENT ],
  [ "--heading", "-h", GetoptLong::REQUIRED_ARGUMENT ],
  [ "--centre", "-c", GetoptLong::NO_ARGUMENT ]
)

opt_decorate = opt_heading = opt_centre = false
heading_template=nil
opts.each do |opt,arg|
  case opt
    when '--decorate' then opt_decorate = true
    when '--heading' then opt_heading = true ; heading_template=arg
    when '--centre' then opt_centre = true
  end
end rescue usage

while i = ARGV.shift
  heading = opt_heading ? heading_template.gsub(/\$/,"#{i}") : nil
  puts multiplication_table(i.to_i, heading, opt_decorate, opt_centre)
  puts unless ARGV.empty?
end
