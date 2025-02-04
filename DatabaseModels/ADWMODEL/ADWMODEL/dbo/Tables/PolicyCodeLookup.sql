CREATE TABLE [dbo].[PolicyCodeLookup] (
    [CodeLookupId]   INT           NOT NULL,
    [TypeCd]         VARCHAR (22)  NOT NULL,
    [TypeDesc]       VARCHAR (200) NOT NULL,
    [LookupEntityNm] VARCHAR (100) NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyCodeLookup] PRIMARY KEY CLUSTERED ([CodeLookupId] ASC) ON [POLICYCD]
) ON [POLICYCD];

