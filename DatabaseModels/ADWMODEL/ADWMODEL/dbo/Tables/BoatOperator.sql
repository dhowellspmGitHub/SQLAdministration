CREATE TABLE [dbo].[BoatOperator] (
    [PolicyId]              INT           NOT NULL,
    [UnitNbr]               INT           NOT NULL,
    [PolicyPartyRelationId] INT           NOT NULL,
    [PolicyNbr]             VARCHAR (16)  NOT NULL,
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
    CONSTRAINT [PK_BoatOperator] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [PolicyPartyRelationId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatOperator_BoatUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[BoatUnit] ([PolicyId], [UnitNbr]),
    CONSTRAINT [FK_BoatOperator_PolicyPartyRelation_01] FOREIGN KEY ([PolicyPartyRelationId]) REFERENCES [dbo].[PolicyPartyRelation] ([PolicyPartyRelationId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_BoatOperator_01]
    ON [dbo].[BoatOperator]([PolicyId] ASC)
    ON [POLICYCI];

