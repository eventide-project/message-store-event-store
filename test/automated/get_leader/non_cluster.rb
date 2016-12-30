require_relative '../automated_init'

context "Get Leader Query On Non-Clustered EventStore" do
  get_leader = EventStore::HTTP::GetLeader.new

  net_http = Controls::NetHTTP::NonCluster.example

  leader = get_leader.(net_http)

  net_http.finish
end
