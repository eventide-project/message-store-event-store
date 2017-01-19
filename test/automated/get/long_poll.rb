require_relative '../automated_init'

context "Get" do
  context "Long poll" do
    context "Is not set" do
      get = EventSource::EventStore::HTTP::Get.build

      test "Long poll is disabled" do
        refute get do
          long_poll_enabled?
        end
      end

      test "Long poll duration is not set on stream reader" do
        assert get.read_stream.long_poll_duration == nil
      end
    end

    context "Is set" do
      get = EventSource::EventStore::HTTP::Get.build long_poll_duration: 11

      test "Long poll is enabled" do
        assert get do
          long_poll_enabled?
        end
      end

      test "Long poll duration is set on stream reader" do
        assert get.read_stream.long_poll_duration == 11
      end
    end
  end
end
