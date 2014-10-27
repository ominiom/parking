require 'csv'

data = File.join(Rails.root, 'db/data.tar.gz')
dest = File.join(Rails.root, 'tmp/data')

FileUtils.mkdir_p(dest)

`tar -xf "#{data}" -C "#{dest}"`

Dir.glob(File.join(dest, '**/*.csv')).each do |file|
  inserts = []

  CSV.foreach(file) do |row|
    time = row[1]
    kind = row[9]

    year, month = "#{time}".split('-')

    latitude  = row[5]
    longitude = row[4]

    next unless year.present? && month.present? && latitude.present? && longitude.present?

    inserts.push %{(#{year}, #{month}, '#{kind}', #{latitude}, #{longitude})}

    # Crime.create!(year: year, month: month, kind: kind, latitude: latitude, longitude: longitude)
  end

  sql = "INSERT INTO crimes (year, month, kind, latitude, longitude) VALUES #{inserts.join(", ")}"
  Crime.connection.execute(sql)
end