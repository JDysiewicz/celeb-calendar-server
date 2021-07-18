defmodule CelebServer.Repo do
  use Ecto.Repo,
    otp_app: :celeb_server,
    adapter: Ecto.Adapters.Postgres
end
