# # frozen_string_literal: true

# require "httparty"
# require "pact/ffi"
# require "pact/ffi/logger"
# require "pact/ffi/mock_server"
# require "pact/ffi/http_consumer"
# require "fileutils"
# require "uri"

# PactFfi::Logger.log_to_buffer(PactFfi::Logger::LogLevel["ERROR"])

# RSpec.describe "new_message spec" do
#   describe "with matching requests" do
#     let(:contents) do
#       {
#         uuid: {
#           "pact:matcher:type": "regex",
#           regex: "^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$",
#           value: "fb5a885f-f7e8-4a50-950f-c1a64a94d500"
#         }
#       }
#     end

#     let(:mock_server_port) { PactFfi.create_mock_server_for_pact(pact, "127.0.0.1:0", false) }
#     let(:pact) { PactFfi.new_pact("http-consumer-2", "http-provider") }
#     let(:interaction) { PactFfi.new_interaction(pact, "A PUT request to generate book cover") }
#     let(:message_pact)  { PactFfi.new_pact("message-consumer-2", "message-provider") }
#     let(:message) do
#       PactFfi.new_message(message_pact, "Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message")
#     end

#     before do
#       PactFfi.with_specification(pact, PactFfi::FfiSpecificationVersion["SPECIFICATION_VERSION_V3"])
#       PactFfi.upon_receiving(interaction, "A PUT request to generate book cover")
#       PactFfi.given(interaction, "A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required")
#       PactFfi.with_request(interaction, "PUT",
#                            "/api/books/fb5a885f-f7e8-4a50-950f-c1a64a94d500/generate-cover")
#       PactFfi.with_header(interaction, PactFfi::FfiInteractionPart["INTERACTION_PART_REQUEST"],
#                           "Content-Type", 0, "application/json")
#       PactFfi.with_body(interaction, PactFfi::FfiInteractionPart["INTERACTION_PART_REQUEST"],
#                         "application/json", "[]")
#       PactFfi.response_status(interaction, 204)
#       length = JSON.dump(contents).length
#       size = length + 1
#       memBuf = FFI::MemoryPointer.new(:uint, length)
#       memBuf.put_bytes(0, JSON.dump(contents))
#       PactFfi.message_expects_to_receive(message,
#                                          "Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message")
#       PactFfi.message_given(message, "A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required")
#       PactFfi.message_with_contents(message, "application/json", memBuf, size)
#     end
#     after do
#       expect(PactFfi.mock_server_matched(mock_server_port)).to be true
#       res_write_pact = PactFfi.write_pact_file(mock_server_port, "./pacts", false)
#       PactFfi.write_message_pact_file(message_pact, "./pacts", false)
#       PactFfi.cleanup_mock_server(mock_server_port)
#       expect(res_write_pact).to be(0)
#     end

#     it "executes the pact test with no errors" do
#       puts "Mock server port=#{mock_server_port}"
#       reified = PactFfi.message_reify(message)
#       puts reified
#       options = {

#         # body: {
#         #   width: '720',
#         #   height: "1080",
#         # },
#         body: [],
#         params: {
#           hostname: "127.0.0.1",
#           port: mock_server_port,
#           path: "/api/books/#{JSON.parse(reified)["contents"]["uuid"]}/generate-cover",
#           method: "PUT",
#           headers: {
#             "Content-Type": "application/json"
#           }
#         }
#       }
#       response = HTTParty.put("http://#{options[:params][:hostname]}:#{mock_server_port}#{options[:params][:path]}", {
#                                 body: options[:body].to_json,
#                                 headers: { "Content-Type" => "application/json" }
#                               })
#       expect(response.body).to eq nil
#       expect(response.code).to eq 204
#     end
#   end
#   describe "with mismatching requests" do
#     let(:contents) do
#       {
#         uuid: {
#           "pact:matcher:type": "regex",
#           regex: "^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$",
#           value: "fb5a885f-f7e8-4a50-950f-c1a64a94d500"
#         }
#       }
#     end

#     let(:mock_server_port) { PactFfi.create_mock_server_for_pact(pact, "127.0.0.1:0", false) }
#     let(:pact) { PactFfi.new_pact("http-consumer-2", "http-provider") }
#     let(:interaction) { PactFfi.new_interaction(pact, "A PUT request to generate book cover") }
#     let(:message_pact)  { PactFfi.new_pact("message-consumer-2", "message-provider") }
#     let(:message) do
#       PactFfi.new_message(message_pact, "Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message")
#     end

#     before do
#       PactFfi.with_specification(pact, PactFfi::FfiSpecificationVersion["SPECIFICATION_VERSION_V3"])
#       PactFfi.upon_receiving(interaction, "A PUT request to generate book cover")
#       PactFfi.given(interaction, "A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required")
#       PactFfi.with_request(interaction, "PUT",
#                            "/api/books/fb5a885f-f7e8-4a50-950f-c1a64a94d500/generate-cover")
#       PactFfi.with_header(interaction, PactFfi::FfiInteractionPart["INTERACTION_PART_REQUEST"],
#                           "Content-Type", 0, "application/json")
#       PactFfi.with_body(interaction, PactFfi::FfiInteractionPart["INTERACTION_PART_REQUEST"],
#                         "application/json", "[]")
#       PactFfi.response_status(interaction, 204)
#       length = JSON.dump(contents).length
#       size = length + 1
#       memBuf = FFI::MemoryPointer.new(:uint, length)
#       memBuf.put_bytes(0, JSON.dump(contents))
#       PactFfi.message_expects_to_receive(message,
#                                          "Book (id fb5a885f-f7e8-4a50-950f-c1a64a94d500) created message")
#       PactFfi.message_given(message, "A book with id fb5a885f-f7e8-4a50-950f-c1a64a94d500 is required")
#       PactFfi.message_with_contents(message, "application/json", memBuf, size)
#     end
#     after do
#       expect(PactFfi.mock_server_matched(mock_server_port)).to be false
#       mismatchers = PactFfi.mock_server_mismatches(mock_server_port)
#       puts JSON.parse(mismatchers)
#       expect(JSON.parse(mismatchers).length).to eql(1)
#       PactFfi.cleanup_mock_server(mock_server_port)
#     end

#     it "executes the pact test with errors" do
#       puts "Mock server port=#{mock_server_port}"
#       reified = PactFfi.message_reify(message)
#       puts reified
#       options = {

#         body: {
#           width: "720",
#           height: "1080"
#         },
#         params: {
#           hostname: "127.0.0.1",
#           port: mock_server_port,
#           path: "/api/books/#{JSON.parse(reified)["contents"]["uuid"]}/generate-cover",
#           method: "PUT",
#           headers: {
#             "Content-Type": "application/json"
#           }
#         }
#       }
#       response = HTTParty.put("http://#{options[:params][:hostname]}:#{mock_server_port}#{options[:params][:path]}", {
#                                 body: options[:body].to_json,
#                                 headers: { "Content-Type" => "application/json" }
#                               })
#       expect(response.code).to eq 500
#       expect(response.body).to include "Request-Mismatch"
#     end
#   end
# end
