<p align="center">
  <a href="https://www.gatsbyjs.org">
    <img alt="Playlist Hunt" src="https://raw.githubusercontent.com/gillkyle/images/master/playlist-hunt/logo-large.png" width="300" />
  </a>
</p>
<p align="center">
  <b>An example full-stack Gatsby app built with open source technologies.</b>
</p>

## Overview

PlaylistHunt is an example app built for teaching workshops that is a simplified version/clone of ProductHunt. It has the following features:

- Authentication with login and signup
- Authorization and role based access
- Submission of new playlists by logged in users
- Upvoting by logged in users

## Setup

To get the base version of the app running—that the excersises in the workshop build on top of—follow these set up steps:

1. Clone the repository:

```shell
git clone https://github.com/gillkyle/playlist-hunt-workshop.git
```

2. Install the dependencies that the project uses with npm/yarn:

```shell
npm install

# or alternately
yarn install
```

3. Create a new Auth0 app:

First click "+ Create Application"

![Create application button on Auth0](https://raw.githubusercontent.com/gillkyle/images/master/ph-setup/create-auth-app.jpeg)

Then give your app a name, select "Single Page Web Applications", and click "Create"

![App creation flow on Auth0](https://raw.githubusercontent.com/gillkyle/images/master/ph-setup/auth-app-flow.jpeg)

4. Copy Auth0 domain and client ID into the `.env.development` file:

Copy the values for Domain and Client ID into the `.env.development` file assigned to `GATSBY_AUTH0_DOMAIN` and `GATSBY_AUTH0_CLIENT_ID` respectively.

![App settings page on Auth0](https://raw.githubusercontent.com/gillkyle/images/master/ph-setup/auth-settings.jpeg)

5. Add `localhost:8000` to your Auth0 app's allowed domains settings to make sure that you can login in development:

![App domain settings page on Auth0](https://raw.githubusercontent.com/gillkyle/images/master/ph-setup/domains.jpeg)

6. Deploy the Hasura GraphQL engine to a free Heroku app:

You can click on this button to be taken straight to the creation flow on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/hasura/graphql-engine-heroku)

Add a name for your project (which will be used as the subdomain on `.herokuapp.com`) and click "Deploy app"

![Deploy flow on Heroku](https://raw.githubusercontent.com/gillkyle/images/master/ph-setup/create-heroku-app.jpeg)

You can click on "View App" when it is finished being created to visit the Hasura app's interface. _The url that Hasura runs at is your Hasura endpoint._

7. Initialize and seed the Hasura app with some tables and data:

Run the following script in the root of the project folder to apply data from the `hasura` folder in this repository to your Hasura app, replacing the placeholder with your endpoint (like `https://playlist-hunt-workshop.herokuapp.com/`)

```shell
npm run hasura-setup --endpoint=https://your-endpoint.herokuapp.com/
```

8. Add you Hasura endpoint to the `.env.development` file so that Gatsby plugins hit the correct database:

Use the Hasura endpoint (where your Hasura app is running) and add it to the `.env.development` file, assigned to the key `GATSBY_API_URL`.

9. Secure your Hasura app by adding password protection:

You can add [an environment variable to your Hasura app on Heroku to password protect it](https://hasura.io/docs/1.0/graphql/manual/deployment/heroku/securing-graphql-endpoint.html#optional-use-the-admin-secret-with-the-cli). Go to "Settings", "Reveal Config Vars", and add a new variable with a key `HASURA_GRAPHQL_ADMIN_SECRET` and the value being the password you would like to use.

![Heroku config vars](https://raw.githubusercontent.com/gillkyle/images/master/ph-setup/heroku-password.jpeg)

10. Add env vars to Heroku for access control:

Create another env var for `HASURA_GRAPHQL_UNAUTHORIZED_ROLE` with a value of `public` (making it so data can be accessible to users that are not logged in).

![More Heroku config vars](https://raw.githubusercontent.com/gillkyle/images/master/ph-setup/heroku-config.jpeg)

Add a final env var for `HASURA_GRAPHQL_JWT_SECRET` with a value matching the long string generated at https://hasura.io/jwt-config/ when you select Auth0, and input your Auth0 domain.

![Hasura JWT secret tool](https://raw.githubusercontent.com/gillkyle/images/master/ph-setup/jwt.jpeg)

11. Connect new users created in Auth0 to Hasura:

When someone signs up, the user created in Auth0 needs to be saved in the database. This can be done with Auth0 rules, which run snippets of code after someone signs up. 2 snippets are included in the `auth0` folder in this repository that you can copy into new Empty Rules on Auth0.

Create 2 new rules, one called `insert-user` with the contents of [the `auth0/insert-user.js` file](https://github.com/gillkyle/playlist-hunt-workshop/blob/master/auth0/insert-user.js) (and replacing the placeholders with the password set in the password protection step, and your Hasura endpoint), and one called `jwt-claim`, copying in the contents of [the `auth0/jwt-claim` file](https://github.com/gillkyle/playlist-hunt-workshop/blob/master/auth0/jwt-claim.js).

12. Run the app with `gatsby develop`:

If you've completed the above steps, you should be able to start the app with `gatsby develop` and see it running at `localhost:8000`. You are able to sign up, and a user will be saved to the database. Your database already has access controls and 2 example tables to get started with.

## Architecture

The site is intended to help exemplify the hybrid nature of web apps—static and dynamic. There are two main pages that fetch a list of playlists:

1. New
1. Top

### New Playlists (Dynamic)

A commonly understood pattern of web apps is fetching data from a server at runtime. The `/` (homepage) route fetches data in the browser and shows a loading state while the data is coming from the backend.

It uses a GraphQL query like this:

```
query PlaylistsQuery {
  playlist(order_by: { created_at: desc }) {
    id
    title
    ...
  }
}
```

### Top Playlists (Static)

A powerful pattern is preparing the data a site will need before hand. Rather than fetching it right when it's asked for by a user's browser, the data can be rendered no the server at buildtime. The `/top` route fetches data at build time and through Gatsby makes the data queryable at buildtime.

It uses a GraphQL that looks very similar:

```
query TopPlaylistsQuery {
  allPlaylist(
    sort: { fields: upvote_count, order: DESC }
    limit: 10
  ) {
    nodes {
      id
      title
      ...
    }
  }
}
```

## Technologies Used

This project relies on several open source libraries and services:

- [Gatsby](https://gatsbyjs.org/)
- [Auth0](https://auth0.com/)
- [Hasura](https://hasura.io/)
- [Apollo Client](https://www.apollographql.com/)
- [Chakra UI](https://chakra-ui.com/)
- [Formik](https://jaredpalmer.com/formik/)

<h2 align="center">
  ▲PlaylistHunt
</h2>
