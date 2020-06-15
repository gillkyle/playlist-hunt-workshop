require("dotenv").config({
  path: `.env.${process.env.NODE_ENV}`,
})

module.exports = {
  plugins: [
    `gatsby-plugin-chakra-ui`,
    `gatsby-plugin-apollo`,
    {
      resolve: `gatsby-plugin-auth0`,
      options: {
        domain: process.env.GATSBY_AUTH0_DOMAIN,
        clientId: process.env.GATSBY_AUTH0_CLIENT_ID,
      },
    },
    `gatsby-plugin-hasura`,
  ],
}
