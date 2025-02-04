CREATE TABLE [dbo].[Property] (
    [PropertyId]     INT            NOT NULL,
    [ActiveInd]      BIT            NOT NULL,
    [RoofPitchCd]    CHAR (2)       NOT NULL,
    [RoofRatingFctr] DECIMAL (4, 3) NOT NULL,
    [RoofShapeCd]    CHAR (2)       NOT NULL,
    [RoofTypeCd]     CHAR (2)       NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]  CHAR (8)       NOT NULL,
    [LastActionCd]   CHAR (1)       NOT NULL,
    [SourceSystemCd] CHAR (2)       NOT NULL,
    CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED ([PropertyId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

