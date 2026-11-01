module.exports = ({ env }) => ({
  miniprogramMediaOrigin: env('MINIPROGRAM_MEDIA_ORIGIN', 'https://www.sofoyo.com'),
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  app: {
    keys: env.array('APP_KEYS')
  }
});
