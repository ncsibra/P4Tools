module Utils
  def self.classify(string)
    string.gsub(/(^|_)(.)/) { $2.upcase }
  end
end

