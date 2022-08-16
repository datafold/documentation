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
scalar Date


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
    items: [Table]
}

type ColumnList implements PagedResult {
    page: PageInfo!
    items: [Column]
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
    paused: Boolean!
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

type UsageStats {
    userName: String!
    direction: String!
    count: Int!
    cumulativeCount: Int!
}

type Table implements BaseItem {
    uid: ID!
    prop: TableProp!
    metadata: [TableMetadata!]
    lastModifiedAt: Datetime
    popularity: Float
    recentAccessCount: Int
    descriptions: [TableDesc!]
    tagIds: [ID!]
    tags: [Tag!]
    columnIds: [ID!]
    columns: [Column!]
    createdBySql: [TableCreatedBySql]
    usageStats: [UsageStats!]
}

type TableProp {
    path: String!
    dataSourceId: ID!
    createdBySessionIds: [Int!]
}

type TableMetadata {
    key: String!
    value: String!
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
    popularity: Float
    recentAccessCount: Int
    usageStats: [UsageStats]
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

union SearchedItem = Tag | Table | Column | BiDashboard | BiHtModel | BiHtSync
union TagConnections = Table | Column | BiDashboard | BiHtModel | BiHtSync

# BI - HIGHTOUCH

type RemoteBiSource {
    remoteId: String!
    name: String!
    sourceType: String!
}

type BiHtSource {
    uid: ID!
    remoteId: String!
    name: String!
    slug: String
    createdAt: Datetime
    updatedAt: Datetime
    parentBiDataSource: BiDataSource
    boundDataSources: [DataSource!]
    databaseName: String
    models: [BiHtModel!]
}

type BiHtDestination {
    uid: ID!
    remoteId: String!
    name: String!
    slug: String
    destType: String
    createdAt: Datetime
    updatedAt: Datetime
    parentBiDataSource: BiDataSource!
}

type BiHtModel {
    uid: ID!
    remoteId: String!
    name: String!
    slug: String
    createdAt: Datetime
    updatedAt: Datetime
    queryType: String!
    rawSql: String
    tableName: String
    source: BiHtSource!
    columns: [BoundColumn!]
    syncs: [BiHtSync!]
    parentBiDataSource: BiDataSource!
}

type BiHtSync {
    uid: ID!
    remoteId: String!
    name: String!
    slug: String
    createdAt: Datetime
    updatedAt: Datetime
    lastRunAt: Datetime
    model: BiHtModel!
    columns: [BiHtMappedColumn!]
    destination: BiHtDestination!
    parentBiDataSource: BiDataSource!
}

type BiHtMappedColumn {
    uid: ID!
    remoteId: String!
    name: String!
    type: String
    referenced: Boolean!
    idMapped: Boolean!
    source: BoundColumn
}

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
    mode,
    hightouch
}

type BiQuery {
    uid: ID!
    remoteId: String!
    name: String!
    user: String
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

union BiHtElement = BiHtSource | BiHtModel | BiHtSync | BiHtDestination

type BiHtElementsList implements PagedResult {
    page: PageInfo!
    items: [BiHtElement!]
}

union BiDataSourceElementList = BiWorkspaceList | BiHtElementsList

type BiDataSourceHtBinding {
    sourceId: String
    dataSourceIds: [Int!]
}

type BiDataSourceHtProps {
    workspace: String
    bindings: [BiDataSourceHtBinding]
}

union BiDataSourceProps = BiDataSourceHtProps

type BiDataSource {
    uid: ID,
    name: String!
    type: BiType!
    org: Organization!,
    props: BiDataSourceProps,
    elements (first: Int, cursor: ID): BiDataSourceElementList
}

union BoundColumnParent = BiHtModel

type BoundColumn implements BaseItem {
    uid: ID!
    name: String!
    upstream: [Column!]
    parent: BoundColumnParent!
}

# Lineage items
union LineagePrimaryEntity = Table | BiDashboard | BiHtModel
union LineageConnectedEntity = Table | Column | BoundColumn | BiDashboard | BiHtModel

enum LineageDirection {
    UPSTREAM,
    DOWNSTREAM,
    OFF_CHART,
    DASHBOARD,
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
    popularity: [Int!]
}

# Search items

enum SearchLabel {
    Table
    Column
    Tag
    BiDashboard,
    BiHtModel,
    BiHtSync
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
    """Returns GQL version"""
    version: String
    # Complex methods
    """
    Returns lineage
    primaryUid - UID of the object that is used for paging
    lineageFilter - filter with properties of lineage
    allowedList - whitelist for column UIDs in primary table - used for paging
                  if empty - all columns in table are used for lineage
    """
    lineage(
        primaryUid: ID!,
        lineageFilter: LineageFilter
        allowedList: [ID!]
    ): LineageResult! @auth
    # Selection
    """
    Searching with ranking
    query - any text or empty
    paths - array in format "datasource-id"[."db".["schema".["table-name"]]]
            only DS id is required - other parts are optional
    tagUids - array of tags for filtering
    dataOwnerIds - array of data owner for filtering
    labels - types of objects to find
    ranking - if true then rank with usage or popularity
    bi_last_used_days - only for BI dashobards - last used time in days
    bi_popularity -array in format [0,4] with 0 as least popular and 4 is most popular
    """
    search(
        query: String,
        paths: [String!]
        tagUids: [ID!]
        dataOwnerIds: [Int!]
        labels: [SearchLabel!]
        ranking: Boolean
        bi_last_used_days: Int,
        popularity: [Int!],
        first: Int
        cursor: ID
    ): SearchList! @auth
    # Base methods
    """Returns current user"""
    me: User! @auth
    """Returns current organization"""
    org: Organization! @auth
    """Returns table based on full path ("datasource-id"."db"."schema"."table-name")"""
    table(path: String): Table @auth
    # Batch methods
    """Returns multiple tables based on UID or datasource ID with paging """
    tables(uids: [ID!], dataSourceId: ID, first: Int, cursor: ID): TableList @auth
    """Returns multiple columns based on UID """
    columns(uids: [ID!]!): ColumnList @auth
    """Returns multiple tags based on UID or datasource ID with paging"""
    tags(uids: [ID!], first: Int, cursor: ID, activeOnly: Boolean): TagList @auth
    """Returns multiple BI workspaces based on UID or BI datasource ID with paging"""
    biWorkspaces(uids: [ID!], biDataSourceId: ID, first: Int, cursor: ID): BiWorkspaceList @auth
    """Returns multiple BI spaces based on UID or BI workspace ID with paging"""
    biSpaces(uids: [ID!], biWorkspaceId: ID, first: Int, cursor: ID): BiSpaceList @auth
    """Returns multiple BI dashboards based on UID or BI dashboards ID with paging"""
    biDashboards(uids: [ID!], biSpaceId: ID, first: Int, cursor: ID): BiDashboardList @auth
    biHtModels(uids: [ID!]): [BiHtModel!] @auth
    # Query methods
    remoteBiHtSources(token: ID, biDataSourceId: Int): [RemoteBiSource!] @auth

    # Usage statistics for tables & columns
    usageStats(uid: ID): [UsageStats] @auth
}

"""Source of object creation"""
enum Source {
    """**Default** source - used when creating using API"""
    API
    """Used when user creates source manually"""
    USER_INPUT
}

"""Basic tag properties"""
input TagInput {
    """**REQUIRED** Tag name"""
    name: String!
    """Tag color in format #fff or #ffffff"""
    color: String
    """Source of tag creation"""
    source: Source
}

"""Helper class for batch tag connection creation"""
input TagConnection {
    """UID of primary tag"""
    tagUid: ID!,
    """UIDs of tables/columns/mode dashboards/ht models or syncs for binding with primary tag"""
    objectUids: [ID!]!
}

"""Description for table"""
input TableDescriptionInput {
    """UID of the described table"""
    tableUid: ID!,
    """Source of table's description creation"""
    source: Source
    """ID of the user who owns table"""
    dataOwnerId: Int
    """Description of the table"""
    description: String
    """URL of the table"""
    url: String
}

input TableMetadataItemInput {
    key: String!
    value: String!
}

input TableMetadataInput {
    tableUid: ID!
    metadata: [TableMetadataItemInput!]
}

input TableMetadataRemovalInput {
    tableUid: ID!
    keys: [String!]
}

type Mutation {
    # TAGS
    """ Creates tags for current org, returns IDs of tags created """
    createTags(inputs: [TagInput]!): [ID]! @auth
    """ Removes tags from current org, returns true if all tags removed """
    removeTags(tagUids: [ID!]!): Boolean! @auth
    """
        Attaches needed tags to tables/columns/mode dashboards/ht models or syncs,
        If attached is set to **false** will remove links instead if possible
        Returns true if all of them are attached
    """
    attachTags(connections: [TagConnection!]!, attached: Boolean): Boolean! @auth
    # TABLES
    """ Sets tables description """
    setTableDescriptions(inputs: [TableDescriptionInput!]!): [Table!]! @auth
    """ Sets or updates metadata in multiple tables """
    setOrUpdateTablesMetadata(inputs: [TableMetadataInput!]!): [Table!]! @auth
    """ Removes metadata from multiple tables """
    removeTablesMetadata(inputs: [TableMetadataRemovalInput!]!): [Table!]! @auth
}
schema {
    query: Query,
    mutation: Mutation
}
```

