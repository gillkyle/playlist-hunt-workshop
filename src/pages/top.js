import React from "react"
import { graphql } from "gatsby"

import { Heading, Text } from "@chakra-ui/core"
import Playlists from "../components/playlists"

export const TOP_PLAYLISTS = graphql`
  query {
    allPlaylist(limit: 10) {
      nodes {
        playlistId
        uri
        title
        description
      }
    }
  }
`

export default ({ data }) => (
  <React.Fragment>
    <Heading as="h1">Top Playlists</Heading>
    <Text textAlign="center">
      The best playlists historically from the community. Updated daily.
    </Text>
    <Playlists playlists={data.allPlaylist.nodes} />
  </React.Fragment>
)
