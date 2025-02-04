CREATE TABLE [dbo].[CommercialGLExposureUnitEndorsement] (
    [EndorsementId]         INT            NOT NULL,
    [UnitNbr]               INT            NOT NULL,
    [PolicyId]              INT            NOT NULL,
    [EndorsementNbr]        CHAR (10)      NOT NULL,
    [PolicyNbr]             VARCHAR (16)   NOT NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [PupilsCnt]             INT            NULL,
    [CreatedTmstmp]         DATETIME       NOT NULL,
    [UserCreatedId]         CHAR (8)       NOT NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialGLExposureUnitEndorsement] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [PolicyId] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLExposureUnitEndorsement_CommercialGLExposureUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[CommercialGLExposureUnit] ([PolicyId], [UnitNbr]),
    CONSTRAINT [FK_CommercialGLExposureUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialGLExposureUnitEndorsement_01]
    ON [dbo].[CommercialGLExposureUnitEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

