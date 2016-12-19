require_relative '../../automated_init'

context "Session Substitute, Get Request" do
  path = Controls::URI::Path::Stream.example
  media_type = Controls::MediaType.example

  context "Substitute has not performed a GET request" do
    substitute = SubstAttr::Substitute.build EventStore::HTTP::Session

    test "Get request predicate returns false" do
      refute substitute do
        get_request?
      end
    end
  end

  context "Get response is set" do
    substitute = SubstAttr::Substitute.build EventStore::HTTP::Session
    substitute.set_response 200, 'some response body'

    context "Substitute has performed a GET request" do
      status_code, response_body = substitute.get path, media_type

      telemetry_data, = substitute.telemetry_sink.records.map &:data

      test "Specified status code is returned" do
        assert status_code == 200
      end

      test "Specified response body is returned" do
        assert response_body == 'some response body'
      end

      context "Get request predicate" do
        test "Returns true if no block is supplied" do
          assert substitute do
            get_request?
          end
        end

        test "Returns true if supplied block returns true" do
          assert substitute do
            get_request? { true }
          end
        end

        test "Returns false if supplied block returns false" do
          refute substitute do
            get_request? { false }
          end
        end

        test "Passes telemetry data to the block" do
          data = nil

          assert substitute do
            get_request? { |_data| data = _data }

            data == telemetry_data
          end
        end
      end

      context "Telemetry data" do
        test "Status code" do
          assert telemetry_data.status_code == status_code
        end

        test "Response body" do
          assert telemetry_data.response_body == response_body
        end

        test "Acceptable media type" do
          assert telemetry_data.acceptable_media_type == media_type
        end
      end
    end
  end

  context "Get response is not set" do
    substitute = SubstAttr::Substitute.build EventStore::HTTP::Session

    context "Substitute has performed a GET request" do
      status_code, response_body = substitute.get path, media_type

      telemetry_data, = substitute.telemetry_sink.records.map &:data

      test "Status code is 404 by default" do
        assert status_code == 404
      end

      test "Response body is not returned by default" do
        assert response_body == nil
      end
    end
  end
end
