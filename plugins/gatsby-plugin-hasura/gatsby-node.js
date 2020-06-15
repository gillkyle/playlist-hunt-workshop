const ApolloClient = require("apollo-boost").default // returns an object that contains ApolloClient, hence the .default
const fetch = require("isomorphic-fetch")
const gql = require("graphql-tag")

const client = new ApolloClient({
  uri: process.env.GATSBY_API_URL + "/v1/graphql",
  fetch,
})

exports.sourceNodes = async ({
  actions,
  createContentDigest,
  createNodeId,
}) => {
  const { createNode } = actions

  const { data } = await client.query({
    query: gql`
      query {
        playlist {
          id
          title
          description
          uri
        }
      }
    `,
  })

  data.playlist.forEach(playlist =>
    createNode({
      ...playlist,
      playlistId: playlist.id,
      id: createNodeId(`Playlist-${playlist.id}`),
      parent: null,
      children: [],
      internal: {
        type: `Playlist`,
        content: JSON.stringify(playlist),
        contentDigest: createContentDigest(playlist),
      },
    })
  )
}
