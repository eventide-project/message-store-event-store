module MessageStore
  module EventStore
    module StreamName
      module Pattern
        def self.get
          @pattern ||= %r{
            \A

            #{optional(projection_prefix)}

            #{category}

            #{optional('-', stream_id)}

            \z
          }x
        end

        def self.optional(*parts)
          inner_pattern = parts.join

          /(?:#{inner_pattern})?/
        end

        def self.projection_prefix
          /\$[[:alnum:]]+-/
        end

        def self.category
          /(?<category>#{entity_and_type_list})/
        end

        def self.entity_and_type_list
          /#{entity}#{optional(':', type_list)}/
        end

        def self.entity
          /(?<entity>[^-:]+)/
        end

        def self.type_list
          /(?<type_list>[[:alnum:]+]+)/
        end

        def self.stream_id
          /(?<stream_id>[[:graph:]]+)/
        end
      end
    end
  end
end
