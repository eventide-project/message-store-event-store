require_relative '../../automated_init'

context "Session Substitute, Connected Predicate" do
  substitute = SubstAttr::Substitute.build EventStore::HTTP::Session

  context "Substitute has not yet connected" do
    test "False is returned" do
      refute substitute.connected?
    end
  end

  context "Substitute has connected" do
    substitute.connect

    test "True is returned" do
      assert substitute.connected?
    end
  end
end
