# contract-keychain

The operating system's secret store from Elixir: Windows Credential Vault, macOS Keychain and the Linux kernel keyring, through one Rustler NIF.

    {:keychain, git: "https://github.com/V-Sekai-fire/contract-keychain"}

    :ok = Keychain.set_password("weftspun", "fabric-zone", "offline-ca-root", seed)
    {:ok, seed} = Keychain.get_password("weftspun", "fabric-zone", "offline-ca-root")
    :ok = Keychain.delete_password("weftspun", "fabric-zone", "offline-ca-root")

An entry is stored under `package.service` and `user`. Values are strings, so a binary secret
goes in as Base64. Every NIF call runs on a dirty I/O scheduler, because the store can block.

## Tests

    mix test                       # 7 PropCheck properties against Keychain.Mock
    mix test --only os_keychain    # the real OS store: set, overwrite, get, delete, then not found

CI runs both on Windows, macOS and Linux.

Extracted from `V-Sekai-fire/interactor-multiplayer-fabric-zone-console` at `d9ad51f`, with
its delete fixed: the NIF exported `delete_credential` while `Keychain` called
`delete_password`, which only the mock defined.
