defmodule Dscan.Repo do
  use Ecto.Repo,
    otp_app: :dscan,
    adapter: Ecto.Adapters.Postgres
end
