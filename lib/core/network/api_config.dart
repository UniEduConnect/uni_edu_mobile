/// Network configuration for talking to the UNI-EDU backend.
///
/// The base URL is read from the `API_BASE_URL` compile-time environment so it
/// can be pointed at different backends without editing source:
///
/// ```powershell
/// flutter run --dart-define=API_BASE_URL=http://192.168.1.50:5115
/// ```
///
/// The default targets `127.0.0.1:5115` and relies on an **adb reverse tunnel**,
/// so it works with **LDPlayer** without changing how the backend is launched
/// (the backend can stay bound to `localhost`). Set the tunnel up once per
/// emulator session from the host:
///
/// ```powershell
/// adb reverse tcp:5115 tcp:5115
/// ```
///
/// With that in place, `127.0.0.1:5115` inside the emulator is forwarded to the
/// host's `localhost:5115`. The tunnel is cleared when the emulator reboots or
/// the adb server restarts — re-run the command if the connection drops.
///
/// This approach needs no LAN IP (so it survives network changes), no firewall
/// rule, and no `--urls 0.0.0.0`. For a desktop/iOS run, `http://localhost:5115`
/// also works directly; to hit a remote backend, override with `--dart-define`.
class ApiConfig {
  ApiConfig._();

  /// Base URL of the REST API, without a trailing slash.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5115',
  );
}
