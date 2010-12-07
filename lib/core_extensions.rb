# Core extensions for Grundlebox
Kernel.class_eval do
  
  def numeric?(object)
    true if Float(object) rescue false
  end
  
  def random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    string = ""
    1.upto(len) { |i| string << chars[rand(chars.size-1)] }
    return string
  end
  
end


String.class_eval do
  
  def strip_html
    gsub(/<\/?[^>]*>/, "")
  end

end

Array.class_eval do
    
  # Returns a CSV string representing this array. Can specify which columns to
  # include in the serialization by using +options[:columns]+
  #
  # Will attempt to access the +default_export_columns+ class variable on the
  # first entry in the array and use that to calculate export columns. If this
  # is not available, will fall back to outputting all ActiveRecord columns,
  # or fail entirely to do anything.
  def to_csv( options={} )
    
    # What columns do we want?
    if options[:columns].blank?
      if (first && first.class.respond_to?( :default_export_columns ))
        options[:columns] ||= first.class.default_export_columns
      end
      return unless first.class.respond_to?( :column_names )
      options[:columns] ||= Hash[*first.class.column_names.map{|c| [c.humanize, c]}.flatten]
    end
    
    return FasterCSV.generate do |csv|
      csv << options[:columns].keys
      self.each do |item|
        csv << options[:columns].values.map{|c| item.send(c) }
      end
    end
    
  end
  
end