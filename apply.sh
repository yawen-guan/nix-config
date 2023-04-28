# We need --impure because nixgl specifically wants to stay impure, which
# is usually denied by flakes.
home-manager switch --impure # --flake ~/.config/home-manager