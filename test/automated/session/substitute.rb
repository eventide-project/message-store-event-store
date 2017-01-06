require_relative '../automated_init'

context "Session Substitute" do
  request = Object.new

  context "No response is set" do
    substitute = SubstAttr::Substitute.build EventSource::EventStore::HTTP::Session

    context "Request is made" do
      response = substitute.(request)

      test "Status code is 404" do
        assert response.code == '404'
      end

      test "Response body is empty text" do
        assert response.body == ''
      end

      test "Reason phrase is \"Not found\"" do
        assert response.message == 'Not found'
      end
    end
  end

  context "Response is set" do
    substitute = SubstAttr::Substitute.build EventSource::EventStore::HTTP::Session

    substitute.set_response 200, 'some-response', reason_phrase: 'OK'

    context "Request is made" do
      response = substitute.(request)

      test "Specified status code is returned" do
        assert response.code == '200'
      end

      test "Specified response body is returned" do
        assert response.body == 'some-response'
      end

      test "Specified reason phrase is returned" do
        assert response.message == 'OK'
      end
    end
  end
end
