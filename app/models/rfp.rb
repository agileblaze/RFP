class Rfp < ActiveRecord::Base
    has_attachment   :content_type => 'application/pdf',
                   :storage => :file_system,
                   :max_size => 4.megabyte,
                   :processor => :none,
                   :path_prefix => "public/rfp"
                  # :partition =>false

end
