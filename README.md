# WPGG — Cliente Flutter

Cliente multiplataforma de **WPGG** (Win Play Get Gold): misiones diarias de League of Legends, wallet de tokens WPGG, estadísticas de Riot y autenticación con cuenta propia o Riot Sign On (RSO).

Soporta **Android**, **iOS** y **Web** (SPA desplegable en Vercel). Arquitectura **Clean Architecture** con capas `data` / `domain` / `presentation` por feature.

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **3.10+** (Dart `^3.10.3`)
- Backend [`wpgg-back`](../wpgg-back) en ejecución (local o remoto)
- Para OAuth Riot en móvil: deep link `wpgg://` configurado (ya incluido en Android)

## Inicio rápido

```bash
# Clonar e instalar dependencias
git clone <repo-url> wpgg-front
cd wpgg-front
flutter pub get
flutter gen-l10n   # genera AppLocalizations desde lib/l10n/*.arb

# Ejecutar (elige plataforma)
flutter run                          # dispositivo/emulador por defecto
flutter run -d chrome                # web
flutter run --dart-define=WPGG_BASE_URL=http://localhost:3000   # API local
```

## Variables de entorno (compile-time)

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `WPGG_BASE_URL` | URL base del API REST (sin `/` final) | `https://wpgg-back-dev.up.railway.app` |

Ejemplo para build de producción web:

```bash
flutter build web --dart-define=WPGG_BASE_URL=https://api.wpgg.lol
```

La URL se define en `lib/core/constants/app_constants.dart` vía `String.fromEnvironment`.

## Plataformas

### Web

- Routing con **path strategy** (sin `#` en la URL).
- Shell dedicado: sidebar + top bar (`lib/core/presentation/web/`).
- Dashboard de misiones en `/home` (`WebDashboardPage`).
- Despliegue SPA: `vercel.json` reescribe todas las rutas a `index.html`.
- **Cookies cross-site**: si el front y el API están en dominios distintos, el backend debe enviar cookies de sesión con `SameSite=None; Secure` o `/auth/refresh` fallará con 401.

### Android / iOS

- Navegación inferior (`AppShellPage`) con pestañas: Home, Misiones, Finanzas, Perfil.
- OAuth Riot móvil vía `flutter_web_auth_2` y deep link `wpgg://auth/riot-callback`.
- `AndroidManifest.xml` registra `CallbackActivity` con scheme `wpgg`.

## Funcionalidades

| Módulo | Descripción |
|--------|-------------|
| **auth** | Registro, login, refresh JWT, reset de contraseña, logout |
| **riot** | Vincular cuenta Riot, perfil de invocador, partidas, ranked |
| **missions** | Home de misiones, picker diario, misiones por día, sync |
| **wallet** | Balance WPGG, transacciones, gráfico de mercado |
| **profile** | Perfil de usuario, retiros on-chain |
| **ddragon** | Datos estáticos de League (campeones, versión) vía CDN/API |
| **splash** | Pantalla inicial y redirección según sesión |

## Flujo OAuth Riot (RSO)

1. El usuario inicia sesión en `/riot/rso/sign-in` (redirige al portal de Riot).
2. Riot devuelve al callback del backend (`/riot/rso/oauth2-callback`).
3. El backend redirige al front con `?riot_session=<código>` en `/auth/riot-callback`.
4. El front llama `POST /auth/riot-session` para obtener la sesión de la app.

Rutas y constantes relevantes: `AppConstants.riotRsoWebSuccessPath`, `riotRsoMobileCallbackUrl`.

## Estructura del proyecto

```
lib/
├── core/                 # Infraestructura compartida
│   ├── constants/        # URLs, colores, tipografías
│   ├── di/               # GetIt — injection_container.dart
│   ├── network/          # Dio, interceptores, refresh 401
│   ├── oauth/            # RSO web / móvil (stubs por plataforma)
│   ├── platform/         # URL strategy, fragment OAuth
│   ├── presentation/     # Shell, scaffold, nav, componentes web
│   ├── router/           # go_router + redirect OAuth
│   └── theme/            # Tema claro/oscuro
├── features/
│   ├── auth/
│   ├── ddragon/
│   ├── missions/
│   ├── profile/
│   ├── riot/
│   ├── splash/
│   └── wallet/
└── l10n/                 # i18n (ARB → AppLocalizations)
```

Cada feature sigue el patrón:

```
feature/
├── data/          # datasources, models, repositories impl
├── domain/        # entities, repositories (abstract), use cases
└── presentation/  # bloc, pages, widgets
```

## Stack principal

- **Estado**: `flutter_bloc` (features), `provider` (tema, locale, DDragon)
- **Routing**: `go_router`
- **HTTP**: `dio` + cookies (`dio_cookie_manager`)
- **Almacenamiento**: `flutter_secure_storage`, `shared_preferences`
- **DI**: `get_it`
- **UI**: Material 3, `flutter_svg`, `fl_chart`, fuentes Lexend Deca / Mont

## Comandos útiles

```bash
flutter analyze
flutter test
flutter gen-l10n
flutter build apk
flutter build web --release
```

## Convenciones de UI

En modales y flujos de la app, usar los botones compartidos:

- **Primario**: `WpggPrimaryButton`
- **Cancelar / secundario**: `WpggCancelButton`

Ver `.cursor/rules/wpgg-buttons.mdc` y `lib/features/auth/presentation/widgets/wpgg_primary_button.dart`.

## Relación con el backend

Este cliente consume el API NestJS de [`wpgg-back`](../wpgg-back). Endpoints principales:

- `POST /auth/*` — autenticación
- `GET /missions/*` — misiones
- `GET /wallet/*` — wallet
- `GET /riot/*` — datos de Riot
- `GET /ddragon/*` — assets de Data Dragon

Configurá `WPGG_BASE_URL` apuntando al entorno correcto (local, dev Railway, producción).

## Licencia

Proyecto privado — todos los derechos reservados.
