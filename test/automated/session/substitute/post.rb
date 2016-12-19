require_relative '../../automated_init'

context "Session Substitute, Post Request" do
  path = Controls::URI::Path::Stream.example
  media_type = Controls::MediaType.example
  request_body = 'some request body'

  context "Substitute has not performed a POST request" do
    substitute = SubstAttr::Substitute.build EventStore::HTTP::Session

    test "Post request predicate returns false" do
      refute substitute do
        post_request?
      end
    end
  end

  context "Substitute has performed a POST request" do
    substitute = SubstAttr::Substitute.build EventStore::HTTP::Session

    status_code = substitute.post path, request_body, media_type

    telemetry_data, = substitute.telemetry_sink.records.map &:data

    test "Status code of 201 is returned by default" do
      assert status_code == 201
    end

    context "Post request predicate" do
      test "Returns true if no block is supplied" do
        assert substitute do
          post_request?
        end
      end

      test "Returns true if supplied block returns true" do
        assert substitute do
          post_request? { true }
        end
      end

      test "Returns false if supplied block returns false" do
        refute substitute do
          post_request? { false }
        end
      end

      test "Passes telemetry data to the block" do
        data = nil

        assert substitute do
          post_request? { |_data| data = _data }

          data == telemetry_data
        end
      end
    end

    context "Telemetry data" do
      test "Status code" do
        assert telemetry_data.status_code == status_code
      end

      test "Request body" do
        assert telemetry_data.request_body == request_body
      end

      test "Content type" do
        assert telemetry_data.content_type == media_type
      end
    end
  end

  context "Response is varied" do
    substitute = SubstAttr::Substitute.build EventStore::HTTP::Session
    substitute.set_response 404

    status_code = substitute.post path, request_body, media_type

    test "Specified status code is returned" do
      assert status_code == 404
    end
  end
end
