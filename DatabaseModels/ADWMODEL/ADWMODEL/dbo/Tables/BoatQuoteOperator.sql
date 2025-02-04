CREATE TABLE [dbo].[BoatQuoteOperator] (
    [UnitNbr]               INT           NOT NULL,
    [QuoteNbr]              VARCHAR (16)  NOT NULL,
    [QuotePartyRelationId]  INT           NOT NULL,
    [BoatOperatorNm]        VARCHAR (100) NULL,
    [BoatOperatorTypeCd]    CHAR (2)      NULL,
    [BirthDt]               DATE          NULL,
    [GenderCd]              CHAR (1)      NULL,
    [MaritalStatusCd]       CHAR (1)      NULL,
    [LicenseNbr]            CHAR (25)     NULL,
    [LicenseStateCd]        CHAR (2)      NULL,
    [ExperiencedOperatorCd] CHAR (2)      NULL,
    [BoatSafetyCourseInd]   CHAR (1)      NULL,
    [ClientReferenceNbr]    CHAR (10)     NULL,
    [UpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]         CHAR (8)      NOT NULL,
    [LastActionCd]          CHAR (1)      NOT NULL,
    [SourceSystemCd]        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_BoatQuoteOperator] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [QuotePartyRelationId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatQuoteOperator_BoatQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[BoatQuoteUnit] ([QuoteNbr], [UnitNbr]),
    CONSTRAINT [FK_BoatQuoteOperator_QuotePartyRelation_01] FOREIGN KEY ([QuotePartyRelationId]) REFERENCES [dbo].[QuotePartyRelation] ([QuotePartyRelationId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_BoatQuoteOperator_01]
    ON [dbo].[BoatQuoteOperator]([QuoteNbr] ASC)
    ON [POLICYCI];

