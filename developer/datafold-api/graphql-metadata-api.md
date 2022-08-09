---
description: >-
  Datafold exposes a GraphQL Metadata API that allows exporting metadata such as
  table and column descriptions and lineage.
---

# GraphQL Metadata API

The API has the following schema:

```graphql
directive @auth on FIELD_DEFINITION
directive @perm(allow: [String!]!) on FIELD_DEFINITION

# Base types
scalar Datetime


interface BaseItem {
    uid: ID!
}

interface PagedResult {
    page: PageInfo!
}

type PageInfo {
    cursor: ID
    total: Int!
    page: Int!
    first: Int!
}

type TableList implements PagedResult {
    page: PageInfo!
    items: [Table!]
}

type ColumnList implements PagedResult {
    page: PageInfo!
    items: [Column!]
}

type TagList implements PagedResult {
    page: PageInfo!
    items: [Tag!]
}

type TagConnectionsList implements PagedResult {
    page: PageInfo!
    items: [TagConnections!]
}

enum TagSource {
    user_input
    dbt
    warehouse
    lineage
}

type Tag implements BaseItem {
    uid: ID!
    name: String!
    color: String
    attached: Boolean!
    initialSource: TagSource,
    connections (first: Int, cursor: ID): TagConnectionsList
}

type Organization implements BaseItem {
    uid: ID!
    name: String!
    users: [User!] @perm(allow:["list_users"])
    dataSources: [DataSource!] @perm(allow:["list_data_sources"])
    biDataSources: [BiDataSource!] @perm(allow:["list_data_sources"])
}

type User implements BaseItem {
    uid: ID!
    org: Organization!
    name: String!
    email: String!
}

type DataSource implements BaseItem {
    uid: ID!
    name: String!
    type: String!
    owner: User!
    org: Organization!
    oneDatabase: Boolean!
    hasSchemaIndexing: Boolean!
    discourageManualProfiling: Boolean!
    createdAt: Datetime!
    databases: [Database!]
    tables (first: Int, cursor: ID): TableList!
}

type Database {
    name: String!
    schemas: [Schema!]
}

type Schema {
    name: String!
    tablesCount: Int!
}

type TableCreatedBySqlQuery {
    text: String!
    timestamp: Datetime
}

type TableCreatedBySql {
    queries: [TableCreatedBySqlQuery]!
    sessionId: Int
    startedAt: Datetime
    completedAt: Datetime
}

type Table implements BaseItem {
    uid: ID!
    prop: TableProp!
    lastModifiedAt: Datetime
    descriptions: [TableDesc!]
    tagIds: [ID!]
    tags: [Tag!]
    columnIds: [ID!]
    columns: [Column!]
    createdBySql: [TableCreatedBySql]
}

type TableProp {
    path: String!
    dataSourceId: ID!
    createdBySessionIds: [Int!]
}

type TableDesc {
    userId: ID!
    dataOwnerId: ID!
    description: String
}

type Column implements BaseItem{
    uid: ID!
    tableId: ID!
    table: Table!
    prop: ColumnProp!
    descriptions: [ColumnDesc!]
    tagIds: [ID!]
    tags: [Tag!]
    upstreamIds: [ID!]
    upstream: [Column!]
    downstreamIds: [ID!]
    downstream: [Column!]
    dashboardIds: [ID!]
    dashboards: [BiDashboard!]
}

type ColumnProp {
    name: String!
    type: String!
    dbType: String!
    number: Int
    description: String
}

type ColumnDesc {
    userId: ID!
    description: String
}

# Unions

union SearchedItem = Tag | Table | Column | BiDashboard
union TagConnections = Table | Column

# BI - MODE

type BiModeReportProp {
    description: String
    githubLink: String
    accountUsername: String
}

type BiModeReportStat {
    createdAt: Datetime
    updatedAt: Datetime
    lastRunAt: Datetime
    viewCount: Int!
    runsCount: Int!
    expectedRuntime: Float
}

union BiDashboardStat = BiModeReportStat
union BiDashboardProp = BiModeReportProp

# BI

enum BiType {
    mode
}

type BiQuery {
    uid: ID!
    remoteId: String!
    name: String!
    usage: Int!
    text: String
    uses: [Column!]
}

type BiDashboardElement {
    uid: ID!
    remoteId: String!
    name: String!
    queries: [BiQuery!]
}

type BiDashboard {
    uid: ID!
    remoteId: String!
    name: String!
    webLink: String
    webPreviewImage: String
    popularity: Float
    stats: BiDashboardStat
    props: BiDashboardProp
    parentDatasource: BiDataSource!
    parentWorkspace: BiWorkspace!
    parentSpace: BiSpace!
    elements: [BiDashboardElement!]
}

type BiDashboardList implements PagedResult {
    page: PageInfo!
    items: [BiDashboard!]
}

type BiSpace {
    uid: ID!
    remoteId: String!
    name: String!
    parentDatasource: BiDataSource
    parentWorkspace: BiWorkspace
    dashboards (first: Int, cursor: ID): BiDashboardList
}

type BiSpaceList implements PagedResult {
    page: PageInfo!
    items: [BiSpace!]
}

type BiWorkspace {
    uid: ID!
    remoteId: String!
    name: String!
    parentDatasource: BiDataSource
    spaces (first: Int, cursor: ID): BiSpaceList
}

type BiWorkspaceList implements PagedResult {
    page: PageInfo!
    items: [BiWorkspace!]
}

type BiDataSource {
    uid: ID,
    name: String!
    type: BiType!
    org: Organization!,
    workspaces (first: Int, cursor: ID): BiWorkspaceList
}

# Lineage items
union LineagePrimaryEntity = Table | BiDashboard
union LineageConnectedEntity = Table | Column | BiDashboard

enum LineageDirection {
    UPSTREAM,
    DOWNSTREAM,
    DASHBOARD,
    OFF_CHART,
    NEXT_BATCH_UPSTREAM,
    NEXT_BATCH_DOWNSTREAM
}

enum LineageType {
    DIRECT
}

type LineageResult {
    primary: LineagePrimaryEntity!
    entities: [LineageConnectedEntity!]
    edges: [LineageEdge!]
}

type LineageEdge {
    direction: LineageDirection!
    type: LineageType!
    sourceUid: ID
    destinationUid: ID
}

input LineageFilter {
    depthUpstream: Int
    depthDownstream: Int
    biLastUsedDays: Int
    biPopularity: [Int!]
}

# Search items

enum SearchLabel {
    Table
    Column
    Tag
    BiDashboard
}

type SearchStatId {
    count: Int!
    item: ID!
}

type SearchStatTag {
    count: Int!
    tag: Tag!
}

type SearchStatLabel {
    count: Int!
    item: SearchLabel!
}

type SearchResult {
    score: Float!
    item: SearchedItem!
}

type SearchStats {
    dataSources: [SearchStatId!]!
    tags: [SearchStatTag!]!
    dataOwnerIds: [SearchStatId!]!
    labels: [SearchStatLabel!]!
}

type SearchList implements PagedResult {
    page: PageInfo!
    stats: SearchStats!
    results: [SearchResult!]
}

type Query {
    version: String
    # Complex methods
    lineage(
        primaryUid: ID!,
        lineageFilter: LineageFilter
        allowedList: [ID!]
    ): LineageResult! @auth
    # Selection
    search(
        query: String,
        paths: [String!]
        tagUids: [ID!]
        dataOwnerIds: [Int!]
        labels: [SearchLabel!]
        ranking: Boolean
        bi_last_used_days: Int,
        bi_popularity: [Int!],
        first: Int
        cursor: ID
    ): SearchList! @auth
    # Base methods
    me: User! @auth
    org: Organization! @auth
    table(path: String): Table @auth
    # Batch methods
    tables(uids: [ID!], dataSourceId: ID, first: Int, cursor: ID): TableList @auth
    columns(uids: [ID!]!): ColumnList @auth
    tags(uids: [ID!], first: Int, cursor: ID, activeOnly: Boolean): TagList @auth
    biWorkspaces(uids: [ID!], biDataSourceId: ID, first: Int, cursor: ID): BiWorkspaceList @auth
    biSpaces(uids: [ID!], biWorkspaceId: ID, first: Int, cursor: ID): BiSpaceList @auth
    biDashboards(uids: [ID!], biSpaceId: ID, first: Int, cursor: ID): BiDashboardList @auth
}

schema {
    query: Query
}
```

