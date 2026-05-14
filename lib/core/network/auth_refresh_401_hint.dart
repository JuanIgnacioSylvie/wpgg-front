/// Texto para 401 en [POST /auth/refresh] (p. ej. tras redirect Riot sin `?riot_session=`).
String authRefresh401Hint() {
  return 'El OPTIONS previo puede responder 204 aunque falle el POST: revisá la fila POST '
      '“refresh” (no solo la OPTIONS).\n'
      'Cuerpo `{}` es normal si no hay `refreshToken` en almacén local: el back puede '
      'esperar cookie HttpOnly, pero tiene que estar asociada al mismo host que '
      'WPGG_BASE_URL (el API). Cookies fijadas solo en el dominio del front (p. ej. '
      'Vercel) no viajan al API en el XHR.\n'
      'Arreglo típico en back: Set-Cookie en el host del API o redirect con '
      '`?riot_session=` y canje con POST /auth/riot-session. /auth/refresh no canjea '
      '`riot_session`.';
}
