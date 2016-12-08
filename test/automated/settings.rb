require_relative './automated_init'

context "Settings" do
  settings = EventStore::HTTP::Settings.build

  context "Names" do
    names = EventStore::HTTP::Settings.names

    names.each do |name|
      test "#{name}" do
        value = settings.get name

        assert value
      end
    end
  end
end
