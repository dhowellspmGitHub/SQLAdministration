CREATE TABLE [dbo].[FireUnitEndorsementDetail] (
    [EndorsementUnitDetailId] INT           NOT NULL,
    [PolicyId]                INT           NOT NULL,
    [EndorsementId]           INT           NOT NULL,
    [UnitNbr]                 INT           NOT NULL,
    [PolicyNbr]               VARCHAR (16)  NOT NULL,
    [EndorsementNbr]          CHAR (10)     NOT NULL,
    [ItemNbr]                 CHAR (3)      NOT NULL,
    [StructureDesc]           VARCHAR (255) NULL,
    [ShortDesc]               VARCHAR (255) NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireUnitEndorsementDetail] PRIMARY KEY NONCLUSTERED ([EndorsementUnitDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitEndorsementDetail_FireUnitEndorsement_01] FOREIGN KEY ([UnitNbr], [PolicyId], [EndorsementId]) REFERENCES [dbo].[FireUnitEndorsement] ([UnitNbr], [PolicyId], [EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitEndorsementDetail_01]
    ON [dbo].[FireUnitEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

