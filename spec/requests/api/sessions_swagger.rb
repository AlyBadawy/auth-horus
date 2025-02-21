require "swagger_helper"

RSpec.describe "Sessions API", type: :request do
  let(:token) { @valid_token }
  let(:Authorization) { "Bearer #{@valid_token}" } # Add this line

  path "/sessions" do
    get "Lists all sessions for the current user" do
      tags "Sessions"
      security [bearer_auth: []]

      response "200", "sessions found" do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :string },
                   user_agent: { type: :string },
                   ip_address: { type: :string },
                   last_active_at: { type: :string, format: "date-time" },
                   created_at: { type: :string, format: "date-time" },
                 },
               }
        run_test!
      end

      response "401", "Unauthorized" do
        run_test!
      end
    end
  end

  path "/session" do
    post "Creates a session" do
      tags "Sessions"
      consumes "application/json"
      produces "application/json"

      parameter name: :credentials,
                in: :body,
                schema: {
                  type: :object,
                  required: [:email_address, :password],
                  properties: {
                    email_address: { type: :string },
                    password: { type: :string },
                  },
                }

      response "201", "session created" do
        schema type: :object,
               properties: {
                 access_token: { type: :string },
                 refresh_token: { type: :string },
                 refresh_token_expires_at: { type: :string, format: "date-time" },
               }
        run_test!
      end

      response "401", "Unauthorized" do
        schema type: :object,
               properties: {
                 error: { type: :string },
                 fix: { type: :string },
               }
        run_test!
      end
    end

    get "Retrieves a session" do
      tags "Sessions"
      security [bearer_auth: []]

      response "200", "session found" do
        schema type: :object,
          properties: {
            id: { type: :string },
            user_agent: { type: :string },
            ip_address: { type: :string },
            last_active_at: { type: :string, format: "date-time" },
            created_at: { type: :string, format: "date-time" },
          }
        run_test!
      end
    end

    put "Refreshes a session" do
      tags "Sessions"
      consumes "application/json"
      produces "application/json"

      parameter name: :token, in: :body, schema: {
        type: :object,
        required: [:refresh_token],
        properties: {
          refresh_token: { type: :string },
        },
      }

      response "201", "session refreshed" do
        schema type: :object,
               properties: {
                 access_token: { type: :string },
                 refresh_token: { type: :string },
                 refresh_token_expires_at: { type: :string, format: "date-time" },
               }
        run_test!
      end

      response "401", "Unauthorized" do
        schema type: :object,
               properties: {
                 error: { type: :string },
               }
        run_test!
      end
    end

    delete "Deletes a session" do
      tags "Sessions"
      security [bearer_auth: []]

      response "204", "session deleted" do
        run_test!
      end
    end
  end
end
