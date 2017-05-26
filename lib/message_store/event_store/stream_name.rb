module MessageStore
  module EventStore
    module StreamName
      def self.stream_name(category_name, id=nil, type: nil, types: nil)
        MessageStore::StreamName.stream_name(
          category_name,
          id,
          type: type,
          types: types
        )
      end

      def self.get_id(stream_name)
        match_data = parse(stream_name)
        match_data[:stream_id]
      end

      def self.get_category(stream_name)
        match_data = parse(stream_name)
        match_data[:category]
      end

      def self.category?(stream_name)
        match_data = parse(stream_name)
        match_data[:stream_id].nil?
      end

      def self.get_type_list(stream_name)
        match_data = parse(stream_name)
        match_data[:type_list]
      end

      def self.get_types(stream_name)
        type_list = get_type_list(stream_name)

        return [] if type_list.nil?

        type_list.split('+')
      end

      def self.get_entity_name(stream_name)
        match_data = parse(stream_name)
        match_data[:entity]
      end

      def self.parse(stream_name)
        pattern = Pattern.get

        pattern.match(stream_name)
      end
    end
  end
end
